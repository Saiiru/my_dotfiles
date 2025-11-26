local ls = require("luasnip")
local s, t, i = ls.snippet, ls.text_node, ls.insert_node

ls.add_snippets("c", {
  s("main", { t({"#include <stdio.h>","","int main(void) {","    "}), i(0), t({"","    return 0;","}"}) }),
})

ls.add_snippets("cpp", {
  s("main", { t({"#include <bits/stdc++.h>","using namespace std;","","int main() {","    ios::sync_with_stdio(false);","    cin.tie(nullptr);","    "}), i(0), t({"","    return 0;","}"}) }),
})

ls.add_snippets("go", {
  s("main", { t({"package main","","import (","    \"fmt\"","    \"testing\""," )","","func main() {","    fmt.Println(\"hello\")","}","","func TestMain(t *testing.T) {","    "}), i(0), t({"","}"}) }),
})

ls.add_snippets("java", {
  s("main", { t({"public class Main {","    public static void main(String[] args) {","        "}), i(0), t({"","    }","}"}) }),
  s("jtest", { t({"@Test","public void should_do_something() {","    // arrange","    ","    // act","    ","    // assert","}"}) }),
})

for _, ft in ipairs({"javascript","typescript","typescriptreact"}) do
  ls.add_snippets(ft, {
    s("test", { t({"import { describe, it, expect } from 'vitest'","","describe('feature', () => {","  it('does something', () => {","    "}), i(0), t({"","  })","})"}) }),
    s("fn", { t("const "), i(1, "name"), t(" = ("), i(2,"args"), t(") => {\n  "), i(0), t("\n}" ) }),
  })
end

ls.add_snippets("python", {
  s("test", { t({"import pytest","","def test_subject():","    "}), i(0), t("") }),
})
