require 'test_helper'

class SmallPageTest < ActionDispatch::IntegrationTest
  include CapyHelper

  setup do
    Capybara.current_driver = Capybara.javascript_driver
    Capybara.default_wait_time = 15
  end

  teardown do
    finish
  end

  test "only first paragraph" do
    login("nixon", "12345")
    page.driver.browser.manage.window.resize_to(900,500)
    visit "/"
    assert page.has_no_content?("Second Paragraph"), "Second paragraph should not be shown."

    visit "/projects/1"
    find("#content_edit").click
    
    wait_for_class("cke_wysiwyg_frame")
    
    page.execute_script <<-SCRIPT
      CKEDITOR.instances["editor1"].setData("");
    SCRIPT
    
    wait_for_id("content_save_button")
    find("#content_save_button").click

    visit "/"

    assert page.has_no_content? "First Paragraph"
    page.driver.browser.manage.window.resize_to(1100,800)
  end
  
end
