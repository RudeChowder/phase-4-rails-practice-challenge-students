class StudentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  def index
    students = Student.all
    render json: students
  end

  def show
    student = find_student
    render json: student
  end

  def update
    student = find_student
    student.update!(student_params)
    render json: student, status: :ok
  end

  def create
    student = Student.create!(student_params)
    render json: student, status: :created
  end

  def destroy
    student = find_student
    student.destroy
    head :no_content
  end

private

  def find_student
    Student.find(params[:id])
  end

  def student_params
    params.permit(:name, :major, :age, :instructor_id)
  end

  def render_not_found
    render json: { error: "Student not found" }, status: :not_found
  end

  def render_unprocessable_entity(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end
