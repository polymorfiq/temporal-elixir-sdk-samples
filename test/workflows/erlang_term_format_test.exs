defmodule TemporalSamples.Workflows.ErlangTermFormatTest do
  use ExUnit.Case

  alias Temporal.{Client, Worker, TaskQueue, Workflow}
  alias TemporalSamples.Workflows.ErlangTermFormat

  require TemporalSamples.Workflows.ErlangTermFormat

  test "greets the world (Erlang style)" do
    # Connect to Temporal Server
    {:ok, client} = Client.new("localhost:7233")

    # Start a worker on the Task Queue
    queue = TaskQueue.new(client, "#{__MODULE__}")
    {:ok, worker} = Worker.new(queue)

    # Register relevant activities and workflows
    :ok = Worker.register_workflow(worker, ErlangTermFormat)

    # Start workflow
    {:ok, handle} =
      TaskQueue.start_workflow(
        queue,
        "erlang-term-format-1",
        ErlangTermFormat,
        [{:etf, [name: "World", first_name: "Bob", last_name: "Smith"]}],
        id_reuse_policy: :terminate_if_running
      )

    # "Received message: Hello, World!"
    {:ok, ["Hello, World!", "Hello, Bob Smith!"]} = Workflow.get(handle)
  end
end
