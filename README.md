# Temporal Elixir SDK (Samples)

These are example workflows that also serve as a set of integration tests for the [Temporal Elixir SDK](https://github.com/polymorfiq/temporal-elixir-sdk)

## Workflow Examples

Workflow examples can be found in [lib/workflows].

## Integration Tests

If running a local instance of Temporal Server, running the test suite will perform integration tests on the SDK.

```bash
git clone git@github.com:polymorfiq/temporal-elixir-sdk-samples.git
cd temporal-elixir-sdk-samples;
mix deps.get;
mix test;
```