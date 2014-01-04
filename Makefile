PREFIX:=../
DEST:=$(PREFIX)$(PROJECT)

REBAR=./rebar

.PHONY: all edoc test clean dialyzer

all:
	@$(REBAR) get-deps compile

edoc:
	@$(REBAR) doc

test:
	@rm -rf .eunit
	@mkdir -p .eunit
	@$(REBAR) skip_deps=true eunit

clean:
	@$(REBAR) clean

dialyzer:
	@$(REBAR) dialyze