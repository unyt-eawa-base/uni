require './university.rb'

def semesters
  [
    :fall2021,
    :spring2022,
    :fall2022,
    :spring2023,
    :fall2023,
    :spring2024,
    :fall2024
  ]
end

def instructors
  {
    'CS' => ['Alan Turing', 'Margaret Hamilton', 'Edgser Dijkstra', 'Michael Stonebreaker', 'David Patterson', 'John Hopcroft'],
    'PHYS' => ['Max Planck', 'Louis de Broglie', 'Marie Curie'],
    'EE' => ['Claude Shannon', 'Gustav Kirchoff', 'Michael Faraday'],
    'MATH' => ['Grigori Perelman', 'Karl Gauss', 'Gottfried Leibnitz', 'George Boole'],
    'IE' => ['George Dantzig', 'John Little'],
    'PHIL' => ['Kurt Godel']
  }
end

def read_students
  students = []
  File.readlines('./students.txt', chomp: true).each do |line|
    students << University::Student.new(line)
  end
  students
end

def read_courses
  courses = []
  File.readlines('./courses.txt', chomp: true).each do |line|
    courses << University::Course.new(line)
  end
  courses
end

def populate_grades
  students = read_students
  courses = read_courses

  File.open('./grades.txt', 'w+') do |f|
    students.each do |s|
      n = (5..20).to_a.sample
      puts "#creating #{n} courses for #{s.full_name}"
      courses.sample(n).each do|c|
        sem = semesters.sample
        grade = University.grade_points.keys.sample
        instructor = instructors[c.department].sample
        line = "#{s.id}, #{c.code}, #{sem}, #{grade}, #{instructor}"
        f.puts(line)
      end
    end
  end
end

def process_grades
  students = read_students
  courses = read_courses
  taken_courses = []

  File.readlines('./grades.txt', chomp: true).each do |line|
    parts = line.split(', ')
    student_id = parts[0].to_i
    student = students.find {|s| s.id == student_id}
    course_code = parts[1]
    course = courses.find {|c| c.code = course_code}
    semester = parts[2]
    grade = parts[3]
    instructor = parts[4]
    tc = University::TakenCourse.new(student, course, semester, grade, instructor)
    student.taken_courses << tc
  end


  students_by_dep = Hash.new([])
  students.each do |s|
    students_by_dep[s.department] += [s]
  end

  students_by_dep.each { |dept,student_list| puts "#{dept} has #{student_list.length} students" }
  top_student = students.max
  puts "#{top_student.full_name} has the highest gpa"
  bottom_student = students.min
  puts "#{bottom_student.full_name} has the lowest gpa"
  students.sort.each {|s| puts "#{s.full_name} has gpa #{s.gpa.round(2)}"}
end

#populate_grades
process_grades