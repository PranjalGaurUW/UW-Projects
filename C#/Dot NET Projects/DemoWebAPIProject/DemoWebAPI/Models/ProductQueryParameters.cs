using System;
namespace DemoWebAPI.Models
{
    public class ProductQueryParameters : QueryParameters
    {
        public decimal? MinPrice { get; set; }
        public decimal? MaxPrice { get; set; }
        public string Name { get; set; } = string.Empty;
    }
}
