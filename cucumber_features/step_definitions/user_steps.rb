# frozen_string_literal: true

Given('There is a user that has been persisted to the database') do
  RailsReadonlyInjector.config.read_only = false
  RailsReadonlyInjector.reload!

  @user = User.create(name: 'Bob')

  expect(@user.persisted?).to eq(true)
end

Given('There is a user that has not been persisted to the database') do
  User.destroy_all

  @user = User.new(name: 'Bob')
end

When('I update the user') do
  begin
    @user.update_attributes(name: 'Fred')
  rescue ActiveRecord::ReadOnlyRecord
  end
end

When('I save the user') do
  begin
    @user.save
  rescue ActiveRecord::ReadOnlyRecord
  end
end

Then('the user should not be updated') do
  @user.reload

  expect(@user.name).to eq('Bob')
end

Then('the user should be updated') do
  @user.reload

  expect(@user.name).to eq('Fred')
end

Then('the user should be saved') do
  @user.reload

  expect(@user.persisted?).to eq(true)
end

Then('the user should not be saved') do
  expect(User.all.length).to eq(0)
end

When("I'm using a web browser and attempt to update the user") do
  visit "/users/#{@user.id}/edit"
  fill_in 'user[name]', with: 'Fred'
  click_on 'Update User'
end

When("I'm using a web browser and attempt to create a user") do
  visit '/users/new'
  fill_in 'user[name]', with: 'Fred'
  click_on 'Create User'
end

Then('the user should be created') do
  expect(User.all.length).to eq(1)
end

Then('I should be able to create a user without any errors') do
  expect { User.create(name: 'Bob') }.not_to raise_error
end
