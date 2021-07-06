defmodule Discuss.Concurrency do
  @moduledoc """
  The Concurrency context.
  """

  def add(a, b) do
    IO.puts(a + b)
  end

  def listen do
    receive do
      {:ok, "hello"} -> IO.puts("World")
    end

    listen()
  end

  def explode, do: exit(:kaboom)

  def run do
    Process.flag(:trap_exit, true)
    spawn_link(Discuss.Concurrency, :explode, [])

    receive do
      {:EXIT, _from_pid, reason} -> IO.puts("Exit reason: #{reason}")
    end
  end

  def run_monitoring do
    spawn_monitor(Discuss.Concurrency, :explode, [])

    receive do
      {:DOWN, _ref, :process, _from_id, reason} -> IO.puts("Exit reason: #{reason}")
    end
  end

  @doc """
    Agents are an abstraction around background processes maintaining state.
    We can access them from other processes withing our application and node.
    The state of our Agent is set to our function's return value
  """
  def demo_agent do
    {:ok, agent} = Agent.start_link(fn -> [1, 2, 3] end)
    Agent.update(agent, fn state -> state ++ [4, 5] end)
    IO.inspect Agent.get(agent, &(&1))

    # When we name an Agent we can refer to it by that instead of its PID:
    Agent.start_link(fn -> [10, 11, 12] end, name: DWNumbers)
    IO.inspect Agent.get(DWNumbers, &(&1))
  end

  @doc """
    Tasks provide a way to execute a function in the background and retrieve its
    return value later. They can be particularly useful when handling expensive
    operations without blocking the application execution.
  """
  def demo_task do
    IO.puts "Enter demo_task"
    task = Task.async(Discuss.Concurrency, :double, [2000])

    IO.puts "Doing other works"

    Task.await(task)

    IO.puts("Finished the main demo_task")
  end

  def double(x) do
    :timer.sleep(2000)
    x * 2
  end
end