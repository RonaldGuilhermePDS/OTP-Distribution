defmodule OtpSupervisor.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    response = "<h1>Hello, OTP Distribution!</h1>"

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  get "/get" do
    values = OtpSupervisor.Cache.get()

    response =
      %{
        actual_node: node(),
        time: DateTime.utc_now()
      }
      |> Map.merge(values)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  get "/put" do
    %{"key" => key, "value" => value} = URI.decode_query(conn.query_string)

    OtpSupervisor.Cache.put(key, value)
    values = OtpSupervisor.Cache.get()

    response =
    %{
      actual_node: node(),
      time: DateTime.utc_now(),
      "#{key}": value
    }
    |> Map.merge(values)
    |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  match _ do
    conn
    |> put_status(404)
    |> put_resp_content_type("application/json")
    |> send_resp(404, "Not Found")
  end
end
