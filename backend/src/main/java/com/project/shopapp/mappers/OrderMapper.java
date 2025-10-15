package com.project.shopapp.mappers;

import com.project.shopapp.dtos.OrderDTO;
import com.project.shopapp.models.Order;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface OrderMapper {

    @Mapping(target = "id", ignore = true)
    Order toEntity(OrderDTO dto);

    @Mapping(target = "id", ignore = true)
    void updateOrderFromDto(OrderDTO dto, @MappingTarget Order order);
}
