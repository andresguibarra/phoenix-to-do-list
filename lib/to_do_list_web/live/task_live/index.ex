defmodule ToDoListWeb.TaskLive.Index do
  use ToDoListWeb, :live_view

  alias ToDoList.Tasks
  alias ToDoList.Tasks.Task

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(ToDoList.PubSub, "tasks")
    {:ok, stream(socket, :tasks, Tasks.list_tasks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp completed_class(task) do
    if task.completed do
      "task-completed"
    else
      ""
    end
  end

  defp past_due_date(task) do
    case task.due_date do
      nil ->
        ""

      due_date ->
        {:ok, local_naive_datetime} = NaiveDateTime.from_erl(:calendar.local_time())

        diff_minutes = NaiveDateTime.diff(due_date, local_naive_datetime) / 60 |> abs
        cond do
          task.completed ->
            completed_class(task)
          diff_minutes <= 30 ->
            "task-past-due-date"
          true ->
            ""
        end
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_info({ToDoListWeb.TaskLive.FormComponent, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  def handle_info({:flash, message}, socket) do
    socket = Phoenix.LiveView.put_flash(socket, :info, message)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:task_created, task}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  @impl true
  def handle_info({:task_updated, task}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  @impl true
  def handle_info({:task_deleted, task}, socket) do
    {:noreply, stream_delete(socket, :tasks, task)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, stream_delete(socket, :tasks, task)}
  end

  @impl true
  def handle_event("toggle_completed",  %{"task-id" => task_id}, socket) do
    task =
      task_id
      |> String.to_integer()
      |> Tasks.get_task!

    updated_task = Map.update!(task, :completed, &(!&1))

    Tasks.update_task(task, Map.from_struct(updated_task))

    {:noreply, stream_insert(socket, :tasks, updated_task)}
  end

end
