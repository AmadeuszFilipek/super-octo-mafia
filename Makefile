.PHONY: main ci_validate ci_execute

main:
	dot docs/state_machine.dot -Tpng > docs/state_machine.png
ci_validate:
	sudo circleci config validate
ci_execute:
	sudo circleci local execute
