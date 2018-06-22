class OverdueController < ApplicationController

    module Overdue
        SMALL  = 0
        AVERAE = 1
        LARGE  = 2
    end

    def overdue_category(overdue)
        if overdue < 2
            return Overdue::SMALL
        elif overdue < 7
            return Overdue::AVERAGE
        else
            return Overdue::LARGE
        end
    end

    def index
        @project = Project.find(params[:project_id])
        @users = Hash.new
        @project.issues.each { |issue|
            if (issue.due_date == nil || issue.assigned_to_id == nil)
                next
            end

            overdue = Time.now.to_date - issue.due_date
            if (overdue <= 0)
                next
            end

            user = User.find(issue.assigned_to_id)
            if (@users[user] == nil)
                @users[user] = Array.new(3) { 0 }
            end

            category = overdue_category(overdue)
            @users[user][category] += 1
        }
  end
end
