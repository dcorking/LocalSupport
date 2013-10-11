require 'spec_helper'

describe "organizations/new.html.erb" do
  before(:each) do
    assign(:organization, stub_model(Organization).as_new_record)
    @tooltips = {'Name'=> 'Enter a strange name'}
  end

  it "renders new organization form" do
    view.lookup_context.prefixes = %w[organizations application]
    render

    rendered.should have_selector("form", :action => organizations_path, :method => "post") do |form|
    end
  end
end
