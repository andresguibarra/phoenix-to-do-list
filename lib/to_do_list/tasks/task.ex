defmodule ToDoList.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :due_date, :naive_datetime
    field :remind_on, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:description, :completed, :remind_on, :due_date])
    |> validate_required([:description, :completed])
  end
end
