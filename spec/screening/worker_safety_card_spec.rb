# frozen_string_literal: true
require 'helper_methods'
require 'react_select_helpers'

describe 'Worker Safety Card', type: :feature do
  before do
    visit '/'
    login_user
    click_link 'Start Screening'
  end

  it 'Saving blank card scenario' do
    within '#worker-safety-card' do
      within '.card-header' do
        expect(page).to have_content('WORKER SAFETY')
      end
      expect(page).to have_content('Worker safety alerts')
      has_react_select_field('Worker safety alerts', with: [])
      expect(page).to have_content('Additional safety information')
      expect(page).to have_field('Additional safety information', with: '')
      expect(page).to have_button('Save')
      expect(page).to have_button('Cancel')
      # Saving a blank card and validating
      click_button 'Save'
      within '.card-header' do
        expect(page).to have_content('WORKER SAFETY')
      end
      within '.card-body' do
        expect(page).to have_content('Worker safety alerts')
        expect(page).to have_content('Additional safety information')
      end
      within '.card-header' do
        expect(page).to have_content('WORKER SAFETY')
        find(:css, 'i.fa.fa-pencil').click
      end
      within '.card-body' do
        expect(page).to have_content('Worker safety alerts')
        has_react_select_field('Worker safety alerts', with: [])
        expect(page).to have_content('Additional safety information')
        expect(page).to have_field('Additional safety information', with: '')
      end
    end
  end

  it 'Selecting and fill in data scenario' do
    within '#worker-safety-card' do
      expect(page).to have_content('Worker safety alerts')
      fill_in_react_select 'Worker safety alerts', with: ['Firearms in Home']
      fill_in_react_select 'Worker safety alerts', with: ['Other']
      fill_in('Additional safety information',
              with: 'There is h@ndgun on the prem1se$. And the dude is mean')
      click_button 'Save'
      expect(page).to have_content('Firearms in Home')
      expect(page).to have_content('Other')
      expect(page).to have_content('Additional safety information')
      expect(page).to have_content(
        'There is h@ndgun on the prem1se$. And the dude is mean'
      )
      # Test cancelling scenario
      within '.card-header' do
        find(:css, 'i.fa.fa-pencil').click
      end
      alert_input = find_field('Worker safety alerts')
      2.times do
        alert_input.send_keys(:backspace)
      end
      has_react_select_field('Worker safety alerts', with: [])
      fill_in_react_select 'Worker safety alerts',
                           with: ['Remote or Isolated Location']
      fill_in('Additional safety information', with: 'Et Tu Brute?')
      # Verify new data was not saved on 'Cancel'
      click_button 'Cancel'
      expect(page).to have_content('Firearms in Home')
      expect(page).to have_content('Other')
      expect(page).to have_content(
        'There is h@ndgun on the prem1se$. And the dude is mean'
      )
    end
  end
end