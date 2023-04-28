defmodule ToDoList.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ToDoList.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        completed: true,
        description: "some description",
        due_date: ~N[2023-04-26 13:36:00],
        remind_on: ~N[2023-04-26 13:36:00]
      })
      |> ToDoList.Tasks.create_task()

    task
  end
end
