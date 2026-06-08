defmodule TemporalSamples.Workflows.HelloWorld do
  use Temporal.Workflow, activities: [greet: 2]
  alias Temporal.Workflow

  #
  # Look in test/workflows/hello_world_test.exs for usage
  #

  def execute(ctx, name) do
    # Schedule activity (non-blocking)
    {:ok, act1} =
      Workflow.execute_activity(ctx, &greet/2, [name], start_to_close_timeout: {1, :seconds})

    # Get result of activity (blocks until finished).
    {:ok, msg} = Workflow.get(ctx, act1)

    # Output result of activity
    {:ok, msg}
  end

  def greet(_ctx, name) do
    {:ok, "Hello, #{name}!"}
  end
end
