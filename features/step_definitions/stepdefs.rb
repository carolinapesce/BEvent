module FridayStepHelper
  def is_it_friday(day)
    if day == 'Friday'
      'TGIF'
    else 
      'Nope'
    end
  end
end
World FridayStepHelper

Given("today is {string}") do |given_day|
  @today = given_day # Write code here that turns the phrase above into concrete actions
end

  When("I ask whether it's Friday yet") do
    @actual_answer = is_it_friday(@today) # Write code here that turns the phrase above into concrete actions
  end

  Then("I should be told {string}") do |expected_answer|
    expect(@actual_answer).to eq(expected_answer) # Write code here that turns the phrase above into concrete actions
  end
