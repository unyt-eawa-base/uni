module University
  @@University_Name = 'UNYT'
  @@Grade_Points = {
    'A' => 4.00,
    'A-' => 3.66,
    'B+' => 3.33,
    'B' => 3.00,
    'B-' => 2.66,
    'C+' => 2.33,
    'C' => 2.00,
    'C-' => 1.66,
    'D+' => 1.33,
    'D' => 1.00,
    'D-' => 0.66,
    'F' => 0.00
  }

  class Course
    attr_accessor :code, :title, :department, :credits

    #expects a line of the form
    # CS101, Introduction to programming, CS, 3
    def initialize(line)
      parts = line.split ', '
      @code = parts[0]
      @title = parts[1]
      @department = parts[2]
      @credits = parts[3].to_i
    end
  end

  class Student
    attr_reader :id, :taken_courses
    attr_accessor :name, :surname, :department

    #expects a line of the form
    # 123, John, Doe, CS
    def initialize(line)
      parts = line.split ', '
      @id = parts[0].to_i
      @name = parts[1]
      @surname = parts[2]
      @department = parts[3]
      @taken_courses = []
    end

    def full_name
      "#{name} #{surname}"
    end

    def earned_credits
      @taken_courses
        .select{ |tc| tc.grade != 'F'}
        .map(&:course)
        .map(&:credits)
        .sum
    end

    def gpa
      total_points = @taken_courses.map(&:earned_points).sum
      total_points / earned_credits
    end

    def <=>(other)
      self.gpa <=> other.gpa
    end
  end

  class TakenCourse
    attr_reader :student, :course, :semester, :instructor, :grade

    def initialize(student, course, semester, grade, instructor)
      @student = student
      @course = course
      @semester = semester
      @grade = grade
      @instructor = instructor
    end

    def earned_points
      gp = University.grade_points[self.grade]
      gp * course.credits
    end


  end

  def self.name
    @@University_Name
  end

  def self.grade_points
    @@Grade_Points
  end
end
