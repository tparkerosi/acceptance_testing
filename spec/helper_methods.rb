# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

def autocompleter_fill_in(label, string)
  input = Capybara.find(:fillable_field, label)
  string.split('').each do |char|
    input.send_keys(char)
    sleep(0.08)
  end
end

def build_regex(words)
  arr = words.map do |word|
    "(?=.*#{Regexp.quote(word)})"
  end
  Regexp.new(arr.join(''))
end

def elements_containing(element, *words)
  elements = page.all(element.to_s, text: build_regex(words))
  elements
end

def clear_field(selector)
  fill_in(selector, with: ' ').send_keys(:backspace)
end

def fill_login_form
  return if ENV['USERNAME'].blank? || ENV['PASSWORD'].blank?
  Capybara.fill_in('username', with: ENV.fetch('USERNAME'))
  Capybara.fill_in('password', with: ENV.fetch('PASSWORD'))
  Capybara.click_button('Sign In')
end

def login_user
  fill_login_form
  begin
    click_link 'Intake'
  rescue
    false
  end
end

def generate_date(start_year = 2000, end_year = 2017)
  FFaker::Time.between(Time.new(start_year), Time.new(end_year)).strftime('%m/%d/%Y')
end

def clear_user_login
  browser = Capybara.current_session.driver.browser
  visit '/perry'

  if browser.respond_to?(:clear_cookies)
    # Rack::MockSession
    browser.clear_cookies
  elsif browser.respond_to?(:manage) and browser.manage.respond_to?(:delete_all_cookies)
    # Selenium::WebDriver
    browser.manage.delete_all_cookies
  else
    raise "Don't know how to clear cookies. Weird driver?"
  end
end

def humanize(string, capitalize_all: false)
  capitalize_all ?
    string.split('_').map(&:capitalize).join(' ') :
    string.split('_').join(' ').capitalize
end
