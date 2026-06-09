defmodule TemporalSamples.Workflows.HelloWorldTest do
  use ExUnit.Case

  alias Temporal.{Client, Worker, TaskQueue, Workflow}
  alias TemporalSamples.Workflows.HelloWorld

  require TemporalSamples.Workflows.HelloWorld

  setup do
    # Connect to Temporal Server
    {:ok, client} = Client.new("localhost:7233")
    on_exit(fn -> Client.stop(client) end)

    {:ok, client: client}
  end

  test "greets the world", %{client: client} do
    # Start a worker on the Task Queue
    queue = TaskQueue.new(client, "#{__MODULE__}")
    {:ok, worker} = Worker.new(queue)

    # Register relevant activities and workflows
    :ok = Worker.register_workflow(worker, HelloWorld)

    # Start workflow
    {:ok, handle} =
      TaskQueue.start_workflow(queue, "hello-world-1", HelloWorld, ["World"],
        id_reuse_policy: :terminate_if_running
      )

    # "Received message: Hello, World!"
    {:ok, "Hello, World!"} = Workflow.get(handle)
  end
end
