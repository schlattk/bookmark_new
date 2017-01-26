# As a time-pressed user
# So that I can quickly go to web sites I regularly visit
# I would like to see a list of links on the homepage


feature '1. see a list of links on the homepage' do
  scenario 'list links' do
    Link.create(title: "google", url: "www.google.com")
    visit '/links'
    within('ul#Links') do
      expect(page).to have_content("google")
    end
  end
  scenario 'create a new link entry and display it' do
    visit '/links/new'
    fill_in :title, with: "bbc"
    fill_in :url, with: "www.bbc.com"
    click_button "submit"
    within('ul#Links') do
      expect(page).to have_content("www.bbc.com")
    end
  end
  scenario 'tagging entries' do
    visit '/links/new'
    fill_in :title, with: "bbc"
    fill_in :url, with: "www.bbc.com"
    fill_in :tag, with: "Sport"
    click_button "submit"
    link = Link.first
    expect(link.tags.map(&:name)).to include('Sport')

  end

  scenario "find links by tag" do
    link = Link.new(title: "bbc", url: "www.bbc.com")
    tag = Tag.first_or_create(name: "sport")
    link.tags << tag
    link.save
    link = Link.new(title: "ft", url: "www.ft.com")
    tag = Tag.first_or_create(name: "finance")
    link.tags << tag
    link.save
    visit ('/tags/finance')
    expect(page).not_to have_content("www.bbc.com")
    expect(page).to have_content("www.ft.com")
    end



end
