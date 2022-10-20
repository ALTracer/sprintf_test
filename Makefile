CFLAGS_COMMON := -std=c11 -Wpedantic -pipe -ffunction-sections -fdata-sections
CFLAGS_HARDENING := -fstack-protector-strong -D_FORTIFY_SOURCE=2 -fPIE
CFLAGS_RELEASE := -Os -DNDEBUG
CFLAGS_DEBUG := -Og -ggdb3 -gz -DDEBUG=1

CFLAGS := $(CFLAGS_COMMON) $(CFLAGS_HARDENING)
LDFLAGS := -Wl,-O1 -Wl,--gc-sections
# -zstack-size=131072
# -Wl,--print-memory-usage
LIBS := -lc -lm

debug: CFLAGS += $(CFLAGS_DEBUG)
release: CFLAGS += $(CFLAGS_RELEASE)

TARGET := sprintf_test
sources := main.c
objects := $(patsubst %.c,%.o,$(wildcard *.c))

BD := ./build

release: $(BD)/.release $(TARGET)
debug: $(BD)/.debug $(TARGET)
all: release

$(BD)/%.o: %.c Makefile
	@mkdir -p $(BD)
	$(CC) $(CFLAGS) -c -o $@ $<

$(TARGET): $(BD)/$(objects)
	$(CC) $(LDFLAGS) -o $@ $? $(LIBS)
	@size $@

list: $(TARGET)
	objdump -CSd $< > $(TARGET).list

$(BD)/.release:
	@if [ -e $(BD)/.debug ]; then rm -rf $(BD); fi
	@mkdir -p $(BD)
	@touch $(BD)/.release

$(BD)/.debug:
	@if [ -e $(BD)/.release ]; then rm -rf $(BD); fi
	@mkdir -p $(BD)
	@touch $(BD)/.debug

# Other rules
clean:
	@rm -vf $(BD)/$(objects) $(TARGET) $(TARGET).list
	@rm -vf $(BD)/.debug $(BD)/.release
	@rmdir -v $(BD)

check:
	cppcheck --enable=all $(sources)
