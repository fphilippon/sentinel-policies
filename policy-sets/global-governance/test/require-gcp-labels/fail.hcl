mock "tfplan/v2" {
  module {
    source = "../../testdata/fail/mock-tfplan-v2.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}

