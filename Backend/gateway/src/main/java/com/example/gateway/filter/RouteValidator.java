package com.example.gateway.filter;

import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import java.util.*;
import java.util.function.Predicate;

@Component
public class RouteValidator {

    public static final List<String> openApiEndpoints = List.of(
            "/register",
            "/login",
            "/eureka",
            "/changePassword");

    public Predicate<ServerHttpRequest> isSecured = new SecurePredicate();

    private class SecurePredicate implements Predicate<ServerHttpRequest> {
        @Override
        public boolean test(ServerHttpRequest request) {
            for (String uri : openApiEndpoints) {
                if (request.getURI().getPath().contains(uri)) {
                    return false;
                }
            }
            return true;
        }
    }
}
