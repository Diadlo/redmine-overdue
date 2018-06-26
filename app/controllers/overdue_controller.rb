class OverdueController < ApplicationController

    module Overdue
        SMALL   = 0
        AVERAGE = 1
        LARGE   = 2
    end

    def overdue_category(overdue)
        if overdue <= 2
            return Overdue::SMALL
        elsif overdue <= 7
            return Overdue::AVERAGE
        else
            return Overdue::LARGE
        end
    end

    def index
        @project = Project.find(params[:project_id])
        @users = Hash.new
        @project.users.each { |user|
            @users[user] = Array.new(3) { 0 }
        }

        @project.issues.each { |issue|
            if (issue.due_date == nil || issue.assigned_to_id == nil)
                next
            end

            overdue = Time.now.to_date - issue.due_date
            if (overdue <= 0)
                next
            end

            user = User.find(issue.assigned_to_id)
            category = overdue_category(overdue)
            @users[user][category] += 1
        }

  end
end
