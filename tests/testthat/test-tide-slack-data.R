test_that("tide_slack_data works", {
  data <- data.frame(
    Station = "Monterey, Monterey Harbor, California",
    DateTime = ISOdate(2015, 1, 1, 10, tz = "PST8PDT"),
    stringsAsFactors = FALSE
  )

  expect_error(chk::check_data(tide_slack_data(data),
    values = list(
      Station = "", DateTime = Sys.time(), SlackDateTime = Sys.time(),
      SlackTideHeight = 1, SlackType = ""
    ),
    nrow = 1, exclusive = TRUE, order = TRUE
  ), NA)
})

test_that("tide_height_data predictions", {
  slack <- tide_slack_data(rtide::monterey)
  expect_equal(slack$MLLW, slack$SlackTideHeight, tolerance = 0.002)
  expect_equal(slack$DateTime, slack$SlackDateTime, tolerance = 30)
  expect_identical(slack$SlackType, rep(c("low", "high"), 4))

  monterey <- rtide::monterey
  monterey$DateTime <- dtt_add_hours(monterey$DateTime, 2L)
  slack2 <- tide_slack_data(monterey)
})
