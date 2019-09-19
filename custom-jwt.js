const passportJwt = require("passport-jwt");
const util = require("util");

function customJwtStrategy(options, verify) {
  //options.jwtFromRequest = passportJwt.ExtractJwt.fromAuthHeaderAsBearerToken();
  options.jwtFromRequest = passportJwt.ExtractJwt.fromUrlQueryParameter(
    "token"
  );
  passportJwt.Strategy.call(this, options, verify);
}

util.inherits(customJwtStrategy, passportJwt.Strategy);

module.exports = {
  Strategy: customJwtStrategy
};
