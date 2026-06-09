defmodule TemporalSamples.Workflows.ErlangTermFormatTest do
  use ExUnit.Case

  require TemporalSamples.Workflows.ErlangTermFormat

  alias Temporal.{Client, Runtime, TaskQueue, Workflow, Worker}
  alias TemporalSamples.Workflows.ErlangTermFormat

  setup do
    # Connect to Temporal Server
    {:ok, runtime} = Runtime.with_id(System.unique_integer())
    {:ok, client} = Client.new("localhost:7233", runtime: runtime)
    on_exit(fn -> Client.stop(client) end)

    {:ok, client: client}
  end

  test "greets the world (Erlang style)", %{client: client} do
    # Start a worker on the Task Queue
    queue = TaskQueue.new(client, "#{__MODULE__}")
    {:ok, worker} = Worker.new(queue)

    # Register relevant activities and workflows
    :ok = Worker.register_workflow(worker, ErlangTermFormat)

    # Start workflow
    {:ok, handle} =
      TaskQueue.start_workflow(
        queue,
        "erlang-term-format-3",
        ErlangTermFormat,
        [{:etf, [name: "World", first_name: "Bob", last_name: "Smith"]}],
        id_reuse_policy: :terminate_if_running
      )

    # "Received message: Hello, World!"
    {:ok, ["Hello, World!", "Hello, Bob Smith!"]} = Workflow.get(handle)
  end
end
