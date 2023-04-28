defmodule ToDoList.CronjobTasks do
  use GenServer
  use Timex
  alias ToDoList.Tasks

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    # Schedule work to be performed at some point
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    tasks = Tasks.list_tasks()

    {:ok, datetime} = NaiveDateTime.from_erl(:calendar.local_time())

    tasks
    |> Enum.filter(fn task -> !task.completed && !is_nil(task.remind_on) end)
    |> Enum.each(fn task ->
      if compare_date_times(task.remind_on, datetime) do
        Phoenix.PubSub.broadcast(
          ToDoList.PubSub,
          "tasks",
          {:flash, "Hey! I'm reminding you about: " <> task.description}
        )
      end
    end)


    # Reschedule once more
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    # In 2 hours
    Process.send_after(self(), :work, 30 * 1000)
  end

  defp compare_date_times(dt1, dt2) do
    %{year: y1, month: m1, day: d1, hour: h1, minute: mi1} = dt1
    %{year: y2, month: m2, day: d2, hour: h2, minute: mi2} = dt2

    y1 == y2 and m1 == m2 and d1 == d2 and h1 == h2 and mi1 == mi2
  end
end
