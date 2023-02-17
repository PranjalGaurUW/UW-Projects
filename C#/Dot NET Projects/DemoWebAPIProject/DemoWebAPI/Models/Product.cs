using System;
using System.Text.Json.Serialization;

namespace DemoWebAPI.Models
{
    public class Product
    {
        public int Id { get; set; }//By convention, a property named Id or <type name>Id will be configured as the primary key of an entity.
        public string Name { get; set; }
        public string Sku { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public bool IsAvailable { get; set; }
        public int CategoryId { get; set; }
        [JsonIgnore]//don't want to serialize below property, as each prod has categ. and each categ. has prod-so to avoid this loop
        public virtual Category Category { get; set; }
    }
}
