package com.food.model;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {

    private int restaurantId;
    private Map<Integer, CartItem> items;

    public Cart() {
        items = new LinkedHashMap<>();
    }

    public Cart(int restaurantId) {
        this.restaurantId = restaurantId;
        items = new LinkedHashMap<>();
    }

    public void addItem(CartItem cartItem) {

        int menuId = cartItem.getMenu().getMenuId();

        if (items.containsKey(menuId)) {

            CartItem existingItem = items.get(menuId);

            existingItem.setQuantity(
                existingItem.getQuantity() + cartItem.getQuantity()
            );

        } else {

            items.put(menuId, cartItem);
        }
    }

    public void updateItem(int menuId, int quantity) {

        if (items.containsKey(menuId)) {

            if (quantity > 0) {

                items.get(menuId).setQuantity(quantity);

            } else {

                items.remove(menuId);
            }
        }
    }

    public void removeItem(int menuId) {

        items.remove(menuId);
    }

    public void clearCart() {

        items.clear();
    }

    public double getTotalAmount() {

        double total = 0;

        for (CartItem cartItem : items.values()) {

            total += cartItem.getMenu().getPrice()
                    * cartItem.getQuantity();
        }

        return total;
    }

    public Collection<CartItem> getCartItems() {

        return items.values();
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    public void setItems(Map<Integer, CartItem> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "Cart [restaurantId=" + restaurantId
                + ", items=" + items + "]";
    }
}