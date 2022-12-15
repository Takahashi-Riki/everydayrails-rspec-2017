require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  let(:user){ FactoryBot.create(:user) }
  let(:project){
    FactoryBot.create(
      :project,
      name: "RSpec tutorial",
      owner: user
    )
  }
  let!(:task){ project.tasks.create!(name: "Finish RSpec tutorial") }

  scenario "user toggles a task", js: true do
    login_as user, scope: :user
    go_to_project "RSpec tutorial"

    completed_task "Finish RSpec tutorial"
    expect_complete_task "Finish RSpec tutorial"

    undo_complete_task "Finish RSpec tutorial"
    expect_incomplete_task "Finish Rspec tutorial"
  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def completed_task(name)
    check name
  end

  def undo_complete_task(name)
    uncheck name
  end

  def expect_complete_task(name)
    aggregate_failures do
      expect(page).to have_css "label.completed", text: name
      expect(task.reload).to be_completed
    end
  end

  def expect_incomplete_task(name)
    aggregate_failures do
      expect(page).to_not have_css "label.completed", text: name
      expect(task.reload).to_not be_completed
    end
  end
end
