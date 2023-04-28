defmodule ToDoList.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :description, :string
      add :completed, :boolean, default: false, null: false
      add :remind_on, :naive_datetime
      add :due_date, :naive_datetime

      timestamps()
    end
  end
end
