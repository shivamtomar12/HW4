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
   assert result
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    expect(page).to have_content(text)
  else
    assert page.has_content?(text)
  end
end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW3. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    
    Movie.create!(movie)
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # You should arrange to add that movie to the database here.
    # You can add the entries directly to the databasse with ActiveRecord methodsQ
  end
  #flunk "Unimplemented"
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
    visit movies_path
    arr=arg1.split(',')
    uncheck('ratings_PG-13')
    uncheck('ratings_G')
    uncheck('ratings_PG')
    uncheck('ratings_R')	
    arr.each do |i|
     val=i.strip.prepend('ratings_')
     check(val)
    end
    click_button('Refresh')
end

Then /^I should see only movies rated "(.*?)"$/ do |arg1|
    result=true
    arr=arg1.split(',')
    arr.size.times do |i|
     arr[i]=arr[i].strip
	 
    end 
    
    app=Array.new
    kpp=Array.new
    all("tr").each do |tr|

      if !tr.has_content?('Rating')
	trarray= tr.text.split(/[\s]/)
	
	
        arr.size.times do |i|
         if(trarray.include?(arr[i]))
	 
	 app << arr[i]
	 else
	 kpp << arr[i]
         end
        end
      end
    end
    if !((kpp.to_set-app.to_set).empty?)
     result=false
    end
    puts "result #{result}"
    assert result 
  
end


Then /^I should see all of the movies$/ do
   rowcount=0
   all("tr").each do
   rowcount=rowcount+1
   end
   rowcount.should==11

      
end

When  /^I have sorted the movies alphabetically$/ do
visit movies_path
click_on "Movie Title"
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |movie1, movie2|
result=false
arr=Array.new
temp=0
all("td").each do |td|
   

   if temp%4==0
    
    arr << td.text
   end
temp=temp+1
end
if arr.index(movie1.strip)<arr.index(movie2.strip)
result=true
else
result=false
end

assert result
puts arr
end

When  /^I have sorted movies in increasing order of release date$/ do
visit movies_path
click_on "Release Date"
end

Then  /^I should see movies sorted in increasing order of release date$/ do
result=false
arr=Array.new
temp=2
all("td").each do |td|
   
  
   if temp%4==0
    
    arr << td.text
   end
temp=temp+1
end
dateArr=Array.new
arr.each do |j|
dateArr << DateTime.parse(j)
end

assert_equal(dateArr,dateArr.sort)

end


