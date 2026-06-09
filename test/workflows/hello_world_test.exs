defmodule TemporalSamples.Workflows.HelloWorldTest do
  use ExUnit.Case
  require TemporalSamples.Workflows.HelloWorld

  alias Temporal.{Client, Runtime, TaskQueue, Workflow, Worker}
  alias TemporalSamples.Workflows.HelloWorld

  setup do
    # Connect to Temporal Server
    {:ok, runtime} = Runtime.with_id(System.unique_integer())
    {:ok, client} = Client.new("localhost:7233", runtime: runtime)
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
