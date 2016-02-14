
import smtdv_util_pkg::*;

// record pattern
module test();

task test_env();
  static string env_name = "TEST_ENV";
  static string env_value = "PASSED";
  //smtdv_util::setenv(env_name, env_value, 1);
  //assert(smtdv_util::getenv(env_name) == env_value);
  setenv(env_name, env_value, 1);
  $display("%s:%s", env_name, getenv(env_name));
  assert(env_value == getenv(env_name));
endtask

initial begin
  test_env(); $display("test env pass");
end

endmodule
