FROM elixir:1.17.1

WORKDIR /app

COPY . . 

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix do deps.get, deps.compile

RUN chmod +x entrypoint.sh

CMD ["./entrypoint.sh"]
