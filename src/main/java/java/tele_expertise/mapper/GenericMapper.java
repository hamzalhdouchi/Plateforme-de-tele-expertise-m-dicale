package java.tele_expertise.mapper;

import java.util.List;

public interface GenericMapper<E, D> {

        D toDTO(E entity);
        E toEntity(D dto);
        List<D> toDTOList(List<E> entities);
        List<E> toEntityList(List<D> dtos);
}
