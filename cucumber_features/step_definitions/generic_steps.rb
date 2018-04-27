# frozen_string_literal: true

Given('I execute:') do |code|
  eval code
end

Then('The page should contain {string}') do |string|
  expect(page).to have_content(string)
end
