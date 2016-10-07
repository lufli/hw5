# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  # Remove this statement when you finish implementing the test step
  movies_table.hashes.each do |movie|
    Movie.create(title: movie[:title], rating: movie[:rating], release_date: movie[:release_date])
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  rating_list = arg1.split(',')
  rating_list.each do |rating|
    rating.strip!
    check("ratings_"+rating)
  end
  click_button('ratings_submit')
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  rating_list = arg1.split(',')
  rating_list.each do |rating|
    rating.strip!
  end
  
  page.all('#movie tr > td:nth-child(2)').each do |td|
    %w{rating_list}.should include td.text
  end
end

Then /^I should see all of the movies$/ do
  page.all('table#movies tbody tr').length == Movie.count
end

When /^I sort by alphabetically$/ do
  click_on 'Movie Title'
end

When /^I sort by release date$/ do
  click_on 'Release Date'
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |m1, m2|
  expect(page.body).to match (/#{m1}.*#{m2}/m)
end




