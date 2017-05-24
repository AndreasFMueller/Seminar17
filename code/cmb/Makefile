# Tools
MAKE = make

# Directories
LIB_DIR = SHCL
BIN_DIR = CMB-Analyzer

.PHONY:	all lib bin clean uninstall

all:	bin

lib:
	$(MAKE) -C $(LIB_DIR)
	$(MAKE) -C $(LIB_DIR) install

bin:	lib
	$(MAKE) -C $(BIN_DIR)
	$(MAKE) -C $(BIN_DIR) install

clean:
	$(MAKE) -C $(LIB_DIR) clean
	$(MAKE) -C $(BIN_DIR) clean

uninstall:
	$(MAKE) -C $(BIN_DIR) uninstall
	$(MAKE) -C $(LIB_DIR) uninstall
