class Overdue

    def time_to_category(overdue)
        if overdue <= 2
            return 0
        elsif overdue <= 7
            return 1
        else
            return 2
        end
    end

    def initialize(user)
        @sum_overdue = 0
        @user = user
        @categories = Array.new(3) { 0 }
    end

    def get_sum()
        return @sum_overdue.to_i
    end

    attr_reader :user
    attr_reader :categories

    def add_overdue(time)
        @sum_overdue += time
        cat = time_to_category(time)
        @categories[cat] += 1
    end
end

class OverdueController < ApplicationController

    def index
        @project = Project.find(params[:project_id])
        users = Hash.new
        @project.users.each { |user|
            users[user] = Overdue.new(user)
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
            users[user].add_overdue(overdue)
        }

        # Reverse order
        @overdues = users.values.sort_by { |overdue| -overdue.get_sum }
  end
end
