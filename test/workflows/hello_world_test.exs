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
    {:ok, worker} = Worker.new(queue, [
      max_cached_workflows: 100,
      deployment_options: [
        version: [build_id: "0.1.0", deployment_name: "elixir-sdk"],
        use_worker_versioning: false,
        default_versioning_behavior: nil
      ],
      task_types: [
        enable_workflows: true,
        enable_local_activities: true,
        enable_remote_activities: true
      ],
      tuner: [
        workflow_slot_supplier: [fixed_size: 10],
        activity_slot_supplier: [fixed_size: 10],
        local_activity_slot_supplier: [fixed_size: 10],
      ]
    ])

    # Register relevant activities and workflows
    :ok = Worker.register_workflow(worker, HelloWorld)

    # Start workflow
    {:ok, handle} =
      TaskQueue.start_workflow(queue, "hello-world-1", HelloWorld, ["World"],
        id_reuse_policy: :terminate_if_running
      )

    # "Received message: Hello, World!"
    {:ok, "Hello, World!"} = Workflow.result(handle)
  end
end
