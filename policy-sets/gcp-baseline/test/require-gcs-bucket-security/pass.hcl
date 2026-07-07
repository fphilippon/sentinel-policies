mock "tfplan/v2" {
  module {
    source = "../../testdata/pass/mock-tfplan-v2.sentinel"
  }
}

test {
  rules = {
    main = true
  }
}
