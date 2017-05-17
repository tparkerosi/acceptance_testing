# frozen_string_literal: true

person1 = {
  fname: 'JOHN',
  mname: 'JACOB',
  lname: 'PERSONONE',
  suffix: 'II',
  suffix2: 'Esq',
  role1: 'Victim',
  role2: 'Mandated Reporter',
  language: 'English',
  language2: 'Cantonese',
  phonenum: '213-432-4400',
  phonetype: 'Cell',
  dob: '08/22/1966',
  gender: 'Female',
  ssn: '765-44-4887',
  addr: '321 S. Main Street',
  city: 'Carmel',
  state: 'California',
  Zip: '90210',
  addrtype: 'Homeless'
}

person2 = {
  fname: 'JIM',
  mname: 'BOB',
  lname: 'PERSONTWO',
  suffix: 'Jr',
  role1: 'Non-mandated Reporter',
  role2: 'Perpetrator'
}

describe 'Partcipant Card tests', type: :feature do
  # Selecting Start Screening on homepage
  before do
    visit '/'
    login_user
    click_link 'Start Screening'
  end

  it 'Test initial rendering of card' do
    within '#search-card', text: 'SEARCH' do
      autocompleter_fill_in 'Search for any person', 'zz'
      click_button 'Create a new person'
      sleep 0.3
    end

    person1_id = find('div[id^="participants-card-"]', text: 'UNKNOWN')[:id]
    person1_card = find('#' + person1_id)
    within person1_card do
      # Verify initial rendering of card
      expect(page).to have_content('UNKNOWN PERSON')
      expect(page).to have_content('First Name')
      expect(page).to have_field('First Name', with: '')
      expect(page).to have_content('Middle Name')
      expect(page).to have_field('Middle Name', with: '')
      expect(page).to have_content('Last Name')
      expect(page).to have_field('Last Name', with: '')
      expect(page).to have_content('Suffix')
      has_react_select_field('Suffix', with: [])
      expect(page).to have_select('Suffix', options: ['', 'Esq', 'II', 'III',
                                                      'IV', 'Jr', 'Sr', 'MD',
                                                      'PhD', 'JD'])
      expect(page).to have_content('Language(s)')
      has_react_select_field('languages', with: [])
      expect(page).to have_content('Role')
      has_react_select_field('Role', with: [])
      click_button 'Add new phone number'
      expect(page).to have_content('Phone Number')
      expect(page).to have_field('Phone Number', with: '')
      expect(page).to have_content('Phone Number Type')
      has_react_select_field('Phone Number Type', with: [])
      expect(page).to have_select('Phone Number Type', options: ['', 'Cell',
                                                                 'Work', 'Home',
                                                                 'Other'])
      expect(page).to have_content('Date of birth')
      expect(page).to have_field('Date of birth', with: '')
      expect(page).to have_content('Gender')
      has_react_select_field('Gender', with: [])
      expect(page).to have_select('Gender', options: ['', 'Male', 'Female',
                                                      'Other'])
      expect(page).to have_content('Social security number')
      expect(page).to have_field('Social security number', with: '')
      click_button 'Add new address'
      expect(page).to have_content('Address')
      expect(page).to have_field('Address', with: '')
      expect(page).to have_content('City')
      expect(page).to have_field('City', with: '')
      expect(page).to have_content('State')
      has_react_select_field('State', with: [])
      expect(page).to have_content('Zip')
      expect(page).to have_field('Zip', with: '')
      expect(page).to have_content('Address Type')
      has_react_select_field('Address Type', with: [])
      expect(page).to have_select('Address Type', options: ['', 'Home',
                                                            'School', 'Work',
                                                            'Placement',
                                                            'Homeless',
                                                            'Other'])
      expect(page).to have_button 'Save'
      expect(page).to have_button 'Cancel'
      click_button 'Save'
      expect(page).to have_content('UNKNOWN PERSON')
      expect(page).to have_content('Unknown person')
      expect(page).to have_content('Name')
      expect(page).to have_content('Gender')
      expect(page).to have_content('Date of birth')
      expect(page).to have_content('Social security number')
      expect(page).to have_content('Phone Number')
      expect(page).to have_content('Phone Number Type')
      expect(page).to have_content('Address')
      expect(page).to have_content('City')
      expect(page).to have_content('State')
      expect(page).to have_content('Zip')
      expect(page).to have_content('Address Type')
    end
  end

  it 'Test reporter logic for roles and cancelling input' do
    within '#search-card', text: 'SEARCH' do
      autocompleter_fill_in 'Search for any person', 'zz'
      click_button 'Create a new person'
      sleep 0.3
    end
    # test header displays correctly when not all names filled-in
    person1_id = find('div[id^="participants-card-"]', text: 'UNKNOWN')[:id]
    person1_card = find('#' + person1_id)
    within person1_card do
      find('input#first_name').click
      fill_in('First Name', with: person1[:fname])
      within '.card-header' do
        expect(page).to have_content("#{person1[:fname]} " \
                                     '(UNKNOWN LAST NAME)')
      end
      role_input = find_field('First Name')
      5.times do
        role_input.send_keys(:backspace)
      end
      fill_in('Last Name', with: person1[:lname])
      expect(page).to have_content('(UNKNOWN FIRST NAME) ' \
                                   "#{person1[:lname]}")
      fill_in('First Name', with: person1[:fname])
      expect(page).to have_content("#{person1[:fname]} " \
                                   "#{person1[:lname]}")
      within '.card-header' do
        expect(page).to have_content("#{person1[:fname]} " \
                                     "#{person1[:lname]}")
      end
      # Fill in blank person card
      within '.card-body' do
        fill_in('Middle Name', with: person1[:mname])
        select person1[:suffix], from: 'Suffix'
        click_button 'Add new phone number'
        fill_in 'Phone Number', with: person1[:phonenum]
        select person1[:phonetype], from: 'Phone Number Type'
        fill_in 'Date of birth', with: person1[:dob]
        fill_in 'Social security number', with: person1[:ssn]
        click_button 'Add new address'
        fill_in 'Address', with: person1[:addr]
        fill_in 'City', with: person1[:city]
        select person1[:state], from: 'State'
        fill_in 'Zip', with: person1[:zip]
        select person1[:gender], from: 'Gender'
        fill_in_react_select 'Language(s)', with: person1[:Language]
        fill_in_react_select 'Language(s)', with: person1[:Language2]
        select person1[:addrtype], from: 'Address Type'
        # validate addition reporters cannot be selected
        fill_in_react_select 'Role', with: person1[:role2]
        fill_in_react_select 'Role', with: 'Non-mandated Reporter'
        has_react_select_field('Role', with: [person1[:role2]])
        click_button 'Save'
      end

      within '.card-header' do
        expect(page).to have_content("#{person1[:fname]} " \
                                     "#{person1[:lname]}")
      end
      within '.card-body' do
        expect(page).to have_content("#{person1[:fname]} #{person1[:mname]}" \
                                     "#{person1[:lname]} #{person1[:suffix]}")
        expect(page).to have_content(person1[:state])
        expect(page).to have_content(person1[:zip])
        expect(page).to have_content(person1[:addrtype])
        expect(page).to have_content(person1[:addr])
        expect(page).to have_content(person1[:phonenum])
        expect(page).to have_content(person1[:phonetype])
        expect(page).to have_content(person1[:gender])
        expect(page).to have_content(person1[:Language])
        expect(page).to have_content(person1[:Language2])
        expect(page).to have_content(person1[:ssn])
        expect(page).to have_content(person1[:city])
      end

      within '.card-header' do
        find(:css, 'i.fa.fa-pencil').click
      end
      within '.card-body' do
        # validate deleting with backspace
        role_input = find_field('Role')
        2.times do
          role_input.send_keys(:backspace)
        end
        # validate cancelling and data remains unchanged from previous
        expect(page).to have_field('First Name', with: person1[:fname])
        expect(page).to have_field('Middle Name', with: person1[:mname])
        expect(page).to have_field('Last Name', with: person1[:lname])
        select person1[:suffix], from: 'Suffix'
        has_react_select_field('languages', with: %w(person1[:language] \
                                                     person1[:language2]))
        has_react_select_field('Gender', with: person1[:lname])
        expect(page).to have_field('Social security number',
                                   with: person1[:ssn])
        expect(page).to have_field('Address', with: person1[:addr])
        expect(page).to have_field('City', with: person1[:city])
        has_react_select_field('State', with: person1[:state])
        expect(page).to have_field('Zip', with: person1[:zip])
        has_react_select_field('Address Type', with: person1[:addrtype])
        expect(page).to have_field('Phone Number', with: person1[:phonenum])
        has_react_select_field('Phone Number Type', with: person1[:phonetype])

        language_input = find_field('languages')
        2.times do
          language_input.send_keys(:backspace)
        end
        has_react_select_field('languages', with: [])
        fill_in_react_select 'languages', with: ['French']
        fill_in 'Middle Name', with: 'Betty'
        select person1[:suffix2], from: 'Suffix'
        fill_in 'Phone Number', with: '111-111-2222'
        select 'Work', from: 'Phone Number Type'
        fill_in 'Social security number', with: '777-88-9999'
        fill_in 'Address', with: person1[:addr]
        fill_in 'City', with: 'San Jose'
        select 'Alabama', from: 'State'
        fill_in 'Zip', with: person1[:zip]
        select 'Male', from: 'Gender'
        select 'Home', from: 'Address Type'
        click_button 'Cancel'
        expect(page).to have_content("#{person1[:fname]} #{person1[:mname]} " \
                                     "#{person1[:lname]} #{person1[:suffix]}")
        expect(page).to have_content(person1[:state])
        expect(page).to have_content(person1[:zip])
        expect(page).to have_content(person1[:language])
        expect(page).to have_content(person1[:language2])
        expect(page).to have_content(person1[:addrtype])
        expect(page).to have_content(person1[:phonenum])
        expect(page).to have_content(person1[:phonetype])
        expect(page).to have_content(person1[:gender])
        expect(page).to have_content(person1[:ssn])
        expect(page).to have_content(person1[:addr])
        expect(page).to have_content(person1[:city])
      end
    end
  end
  it 'Test two people can be reporter and multiselect in same screening' do
    within '#search-card', text: 'SEARCH' do
      autocompleter_fill_in 'Search for any person', 'zz'
      click_button 'Create a new person'
      sleep 0.3
    end
    person1_id = find('div[id^="participants-card-"]', text: 'UNKNOWN')[:id]
    person1_card = find('#' + person1_id)
    within person1_card do
      find('input#first_name').click
      fill_in('First Name', with: person1[:fname])
      fill_in('Last Name', with: person1[:lname])
      fill_in_react_select 'Role', with: person1[:role1]
      fill_in_react_select 'Role', with: person1[:role2]
      has_react_select_field('Role', with: [person1[:role1], person1[:role2]])
      click_button 'Save'
      expect(page).to have_content("#{person1[:fname]} " \
                                   "#{person1[:lname]}")
    end
    within '#search-card', text: 'SEARCH' do
      autocompleter_fill_in 'Search for any person', 'zz'
      click_button 'Create a new person'
      sleep 0.3
    end
    person2_id = find('div[id^="participants-card-"]', text: 'UNKNOWN')[:id]
    person2_card = find('#' + person2_id)
    within person2_card do
      find('input#first_name').click
      fill_in('First Name', with: person2[:fname])
      fill_in('Middle Name', with: person2[:mname])
      fill_in('Last Name', with: person2[:lname])
      fill_in_react_select 'Suffix', with: person2[:suffix]
      fill_in_react_select 'Role', with: person2[:role1]
      has_react_select_field('Role', with: [person2[:role1]])
      click_button 'Save'
      expect(page).to have_content("#{person2[:fname]} #{person2[:mname]} " \
                                   "#{person2[:lname]}, #{person2[:suffix]}")
      within '.card-header' do
        find(:css, 'i.fa.fa-pencil').click
      end
      # validate once reporter role is deleted by clicking th 'x' or
      # backspace, other reporters are available
      find(:css, 'span.Select-value-icon').click
      fill_in_react_select 'Role', with: 'Anonymous Reporter'
      has_react_select_field('Role', with: ['Anonymous Reporter'])
      role_input = find_field('Role')
      2.times do
        role_input.send_keys(:backspace)
      end
      fill_in_react_select 'Role', with: 'Non-mandated Reporter'
      has_react_select_field('Role', with: ['Non-mandated Reporter'])
    end
  end
  it 'Test char length and different combo for First, Middle, Last Name' do
    within '#search-card', text: 'SEARCH' do
      autocompleter_fill_in 'Search for any person', 'zz'
      click_button 'Create a new person'
      sleep 0.3
    end
    person2_id = find('div[id^="participants-card-"]', text: 'UNKNOWN')[:id]
    person2_card = find('#' + person2_id)
    within person2_card do
      find('input#first_name').click
      fill_in('First Name', with: '')
      fill_in('Middle Name', with: person2[:mname])
      fill_in('Last Name', with: '')
      expect(page).to have_content("UNKNOWN #{person2[:mname]}")

      # First and Middle Name
      fill_in('First Name', with: person2[:fname])
      expect(page).to have_content(
        "#{person2[:fname]} #{person2[:mname]} (UNKNOWN LAST NAME)"
      )
      # First, Middle and Suffix
      select person2[:suffix], from: 'Suffix'
      expect(page).to have_content(
        "#{person2[:fname]} #{person2[:mname]} (UNKNOWN LAST NAME), #{person2[:suffix].upcase}"
      )
      # Middle, Last and suffix
      fill_in('Last Name', with: person2[:lname])
      clear_field 'First Name'
      expect(page).to have_content(
        "(UNKNOWN FIRST NAME) #{person2[:mname]} #{person2[:lname]}, #{person2[:suffix].upcase}"
      )
      # Middle and suffix
      clear_field 'Last Name'
      expect(page).to have_content(
        "UNKNOWN #{person2[:mname]}, #{person2[:suffix].upcase}"
      )
      # Suffix only
      clear_field 'Middle Name'
      select person2[:suffix], from: 'Suffix'
      expect(page).to have_content('UNKNOWN PERSON')

      # First and Suffix
      fill_in('First Name', with: person2[:fname])
      expect(page).to have_content(
        "#{person2[:fname]} (UNKNOWN LAST NAME), #{person2[:suffix].upcase}"
      )

      # last and Suffix
      clear_field 'First Name'
      fill_in('Last Name', with: person2[:lname])
      expect(page).to have_content(
        "(UNKNOWN FIRST NAME) #{person2[:lname]}, #{person2[:suffix].upcase}"
      )

      # Middle and Last
      select '', from: 'Suffix'
      fill_in('Middle Name', with: person2[:mname])
      expect(page).to have_content(
        "(UNKNOWN FIRST NAME) #{person2[:mname]} #{person2[:lname]}"
      )
    end
  end
end
