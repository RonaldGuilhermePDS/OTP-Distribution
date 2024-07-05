defmodule OtpSupervisor.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    response = "<h1>Hello, OTP Distribution!</h1>"

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, response)
  end

  get "/get" do
    response =
      %{ time: DateTime.utc_now() }
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  get "/put" do
    %{"key" => key, "value" => value} = URI.decode_query(conn.query_string)

    response =
    %{
      time: DateTime.utc_now(),
      "#{key}": value
    }
    |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  match _ do
    conn
    |> put_status(404)
    |> put_resp_content_type("text/plain")
    |> send_resp(404, "Not Found")
  end
end
