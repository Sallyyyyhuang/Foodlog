class ArchivesController < ApplicationController
  def index
    @entries = Entry.all.group_by(&:day)

    weekly_entries = Entry.where(created_at: 7.days.ago.beginning_of_day..)
    @weekly_summary = weekly_entries
      .sort_by(&:created_at)
      .group_by { |e| e.created_at.strftime("%b %e, %Y") }
      .sort_by { |date, _| Date.strptime(date, "%b %e, %Y") }
      .reverse
  end
end
