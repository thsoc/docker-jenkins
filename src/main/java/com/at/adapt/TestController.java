package com.at.adapt;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@RequestMapping("/test")
@Slf4j
public class TestController {

    @GetMapping("/query/{name}")
    public String query(@PathVariable String name) throws IOException {
        String helloMsg = name + ",你好" + "!!!!!";
        return helloMsg;
    }
}
