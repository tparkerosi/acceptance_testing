# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'

describe 'Incident Information card', type: :feature do
  before do
    visit '/'
    login_user
    click_link 'Start Screening'
  end
  # Selecting Start Screening on homepage
  it 'Test Incident Info card' do
    # Set variable to test 64 char limit and fields to accept any char
    tst_cty = 'Del Norte'
    tst_addr = '2870 Gateway Elm Way'
    tst_city = 'Hartford'
    tst_state = 'Connecticut'
    tst_zip = '34578'
    tst_loc = 'Child\'s Home'
    tst_cty2 = 'Inyo'
    tst_addr2 = '5479 Holly Street'
    tst_city2 = 'New York'
    tst_state2 = 'New York'
    tst_zip2 = '89078'
    tst_loc2 = 'BDDS'

    within '#incident-information-card' do
      within '.card-header' do
        expect(page).to have_content 'Incident Information'
      end
      within '.card-body' do
        select tst_cty, from: 'Incident County'
        fill_in('Address', with: tst_addr)
        fill_in('City', with: tst_city)
        select tst_state, from: 'State'
        select tst_loc, from: 'Location Type'
        fill_in('Zip', with: tst_zip)
        click_button 'Save'
        # validate content of show view
        expect(page).to have_content 'Incident Date'
        expect(page).to have_content 'Incident County'
        expect(page).to have_content tst_cty
        expect(page).to have_content 'Address'
        expect(page).to have_content tst_addr
        expect(page).to have_content 'City'
        expect(page).to have_content tst_city
        expect(page).to have_content 'State'
        expect(page).to have_content tst_state
        expect(page).to have_content 'Zip'
        expect(page).to have_content tst_zip
        expect(page).to have_content 'Location Type'
        expect(page).to have_content tst_loc
      end
      within '.card-header' do
        expect(page).to have_content 'Incident Information'
        click_link 'Edit'
        expect(page).to have_content 'Incident Information'
      end
      within '.card-body' do
        # Verify saved info is filled in in edit view
        expect(page).to have_select('Incident County', selected: tst_cty)
        expect(page).to have_field('Address', with: tst_addr)
        expect(page).to have_field('City', with: tst_city)
        expect(page).to have_select('State', selected: tst_state)
        expect(page).to have_field('Zip', with: tst_zip)
        expect(page).to have_select('Location Type', selected: tst_loc)
        # Change info in edit view
        select tst_cty2, from: 'Incident County'
        fill_in('Address', with: tst_addr2)
        fill_in('City', with: tst_city2)
        select tst_state2, from: 'State'
        select tst_loc2, from: 'Location Type'
        fill_in('Zip', with: tst_zip2)
        click_button 'Cancel'
        # validate content of show view contains previously saved info
        expect(page).to have_content 'Incident Date'
        expect(page).to have_content 'Incident County'
        expect(page).to have_content tst_cty
        expect(page).to have_content 'Address'
        expect(page).to have_content tst_addr
        expect(page).to have_content 'City'
        expect(page).to have_content tst_city
        expect(page).to have_content 'State'
        expect(page).to have_content tst_state
        expect(page).to have_content 'Zip'
        expect(page).to have_content tst_zip
        expect(page).to have_content 'Location Type'
        expect(page).to have_content tst_loc
      end
      within '.card-header' do
        expect(page).to have_content 'Incident Information'
        click_link 'Edit'
        expect(page).to have_content 'Incident Information'
      end
      within '.card-body' do
        # Verify saved info is filled in in edit view
        expect(page).to have_select('Incident County', selected: tst_cty)
        expect(page).to have_field('Address', with: tst_addr)
        expect(page).to have_field('City', with: tst_city)
        expect(page).to have_select('State', selected: tst_state)
        expect(page).to have_field('Zip', with: tst_zip)
        expect(page).to have_select('Location Type', selected: tst_loc)
        # Change infor in edit view
        select tst_cty2, from: 'Incident County'
        fill_in('Address', with: tst_addr2)
        fill_in('City', with: tst_city2)
        select tst_state2, from: 'State'
        select tst_loc2, from: 'Location Type'
        fill_in('Zip', with: tst_zip2)
        click_button 'Save'
        # validate content of show view contains previously saved info
        expect(page).to have_content 'Incident Date'
        expect(page).to have_content 'Incident County'
        expect(page).to have_content tst_cty2
        expect(page).to have_content 'Address'
        expect(page).to have_content tst_addr2
        expect(page).to have_content 'City'
        expect(page).to have_content tst_city2
        expect(page).to have_content 'State'
        expect(page).to have_content tst_state2
        expect(page).to have_content 'Zip'
        expect(page).to have_content tst_zip2
        expect(page).to have_content 'Location Type'
        expect(page).to have_content tst_loc2
      end
    end
  end

  it 'limits characters in the incident address zip field' do
    within '#incident-information-card.edit' do
      fill_in 'Zip', with: '9i5%6Y1 8-_3.6+9*7='
      expect(page).to have_field('Zip', with: '95618-3697')
      fill_in 'Zip', with: '9i5%6Y1 8'
      expect(page).to have_field('Zip', with: '95618')
    end
  end

  it 'does not allow incident date to be in the future' do
    message = 'The incident date and time cannot be in the future.'
    within '#incident-information-card.edit' do
      expect(page).not_to have_content(message)
      fill_in_datepicker 'Incident Date', with: 10.years.from_now
      expect(page).to have_content(message)
      click_button 'Save'
    end

    within '#incident-information-card.show' do
      expect(page).to have_content(message)
      click_link 'Edit'
    end

    within '#incident-information-card.edit' do
      expect(page).to have_content(message)
      fill_in_datepicker 'Incident Date', with: 1.month.ago
      expect(page).not_to have_content(message)
      click_button 'Save'
    end

    within '#incident-information-card.show' do
      expect(page).not_to have_content(message)
    end
  end
end
