Given("There is a user that has been persisted to the database") do
  @user = User.create(name: 'Bob')


  expect(@user.persisted?).to eq(true)
end

Given("There is a user that has not been persisted to the database") do
  @user = User.new(name: 'Bob')
end

When("I update the user") do
  begin
    @user.update_attributes(name: 'Fred')
  rescue ActiveRecord::ReadOnlyRecord
  end
end

When("I save the user") do
  begin
    @user.save
  rescue ActiveRecord::ReadOnlyRecord
  end
end

Then("the user should not be updated") do
  @user.reload
  
  expect(@user.name).to eq('Bob')
end

Then("the user should be updated") do
  expect(@user.name).to eq('Fred')
end

Then("the user should be saved") do
  expect(@user.persisted?).to eq(true)
end

Then("the user should not be saved") do
  expect(@user.persisted?).to eq(false)
end