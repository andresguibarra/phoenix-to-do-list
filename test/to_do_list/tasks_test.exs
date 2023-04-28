defmodule ToDoList.TasksTest do
  use ToDoList.DataCase

  alias ToDoList.Tasks

  describe "tasks" do
    alias ToDoList.Tasks.Task

    import ToDoList.TasksFixtures

    @invalid_attrs %{completed: nil, description: nil, due_date: nil, remind_on: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{completed: true, description: "some description", due_date: ~N[2023-04-26 13:36:00], remind_on: ~N[2023-04-26 13:36:00]}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.completed == true
      assert task.description == "some description"
      assert task.due_date == ~N[2023-04-26 13:36:00]
      assert task.remind_on == ~N[2023-04-26 13:36:00]
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{completed: false, description: "some updated description", due_date: ~N[2023-04-27 13:36:00], remind_on: ~N[2023-04-27 13:36:00]}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.completed == false
      assert task.description == "some updated description"
      assert task.due_date == ~N[2023-04-27 13:36:00]
      assert task.remind_on == ~N[2023-04-27 13:36:00]
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
