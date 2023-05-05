defmodule WorkerTest do
  @moduledoc """
  Main worker (get_banner) tests
  """
  use ExUnit.Case, async: true

  alias BinoculoDaemon.Worker
  alias BinoculoDaemon.Stub.Server

  setup_all do
    spawn(Server, :start, [21_210])
    :ok
  end

  describe "Testing the banner grab function" do
    test "get banner passing ip + port" do
      host_ut = "127.0.0.1"
      port_ut = 21_210
      {:ok, %{response: response, host: host, port: port}} = Worker.get_banner(host_ut, port_ut)

      assert host_ut == host
      assert port_ut == port
      assert response =~ ~r/ftp/i
    end

    test "get error and reason when port is not open in host" do
      host_ut = "127.0.0.1"
      port_ut = 9999

      {:error, %{response: response, host: host, port: port}} =
        Worker.get_banner(host_ut, port_ut)

      assert host_ut == host
      assert port_ut == port
      assert response =~ ~r/Error returning banner/i
    end

    test "get error and reason when host is not reachable" do
      host_ut = "1.1.1.1"
      port_ut = 9999

      {:error, %{response: response, host: host, port: port}} =
        Worker.get_banner(host_ut, port_ut)

      assert host_ut == host
      assert port_ut == port
      assert response =~ ~r/Error returning banner/i
    end
  end
end
