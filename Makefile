# Makefile

SRCTOP=..

include $(SRCTOP)/build/vars.mak


build: package
unittest: 
systemtest: systemtest-setup mysystemtest-run

systemtest-setup:
	$(EC_PERL) systemtest/setup.pl $(TEST_SERVER) $(PLUGINS_ARTIFACTS)

mysystemtest-run: NTESTFILES ?= systemtest

mysystemtest-run: systemtest-run

include $(SRCTOP)/build/rules.mak
